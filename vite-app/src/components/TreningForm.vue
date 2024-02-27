<template>
    <div>
      <h3>Stwórz Trening</h3>
      <InputText v-model="trening.nazwa" placeholder="Nazwa Treningu" maxlength="100"  @keypress="validateCharacter"/>
      <Calendar v-model="trening.data" :showIcon="true" dataType="date" placeholder="wybierz date" :minDate="today" />
      <Calendar v-model="trening.godzina" :showIcon="false" timeOnly hourFormat="24" placeholder="wybierz godzine" :stepMinute="5" />

            <h4>Wybierz Ćwiczenia</h4>
          <div v-for="cwiczenie in cwiczenia" :key="cwiczenie.id">
            <input type="checkbox" :value="cwiczenie.id" v-model="wybraneCwiczenia">
            {{ cwiczenie.nazwa }}
          </div>
          <h4>Wybierz Gotowy Plan</h4>
          <div v-for="plan in plany" :key="plan.id" @dblclick="wybierzPlan(plan.id)">
            {{ plan.nazwa }}
          </div>

      <Button label="Zapisz" @click="saveTrening" />
    </div>
  </template>
  
  <script>
    import axios from 'axios';
    import InputText from 'primevue/inputtext';
    import Calendar from 'primevue/calendar';
    import Button from 'primevue/button';
    import moment from 'moment';

  export default {
    components: {
    InputText,
    Calendar,
    Button
  },
    data() {
      return {
        today: new Date(),
        trening: {
          nazwa: '',
          data: '',
          godzina: '',
          grupaTreningowaId: null,
          cwiczenia: [],
        },
        grupyTreningowe: [], // Dodane do przechowywania grup treningowych
      cwiczenia: [], // Dodane do przechowywania ćwiczeń
      wybraneCwiczenia: [], // Dodane do przechowywania ID wybranych ćwiczeń
      plany: [],
      };
    },
    created() {
      this.fetchGrupyTreningowe();
      this.fetchCwiczenia();
      this.fetchPlany();

      if (this.$route.params.grupaTreningowaId) {
     this.trening.grupaTreningowaId = this.$route.params.grupaTreningowaId;
      }

},
    methods: {

      validateCharacter(event) {
      // Definiuje dozwolone znaki
      const allowedCharacters = /[a-zA-Z0-9 ()ąęćłńóśźżĄĘŁŃÓŚĆŹŻ]/;
      if (!allowedCharacters.test(event.key)) {
        event.preventDefault(); // Zapobiega wprowadzeniu znaku, jeśli jest niedozwolony
      }
    },


        fetchGrupyTreningowe() {
    axios.get('http://127.0.0.1:8000/api/trener-grupy')
      .then(response => {
        this.grupyTreningowe = response.data;
      })
      .catch(error => {
        console.error("There was an error fetching the trening groups:", error);
      });
  },
  fetchCwiczenia() {
    axios.get('http://127.0.0.1:8000/api/cwiczenia')
      .then(response => {
        this.cwiczenia = response.data;
      })
      .catch(error => {
        console.error("There was an error fetching the exercises:", error);
      });
  },
  fetchPlany() { 
      axios.get('http://127.0.0.1:8000/api/gotowy-plan')
        .then(response => {
          this.plany = response.data;
        })
        .catch(error => {
          console.error("There was an error fetching the plans:", error);
        });
    },



    saveTrening() {


      const selectedDate = moment(this.trening.data);
  const selectedTime = moment(this.trening.godzina, 'HH:mm');
  const now = moment();

  // Sprawdzanie, czy data jest dzisiejsza i czy wybrana godzina jest wcześniejsza niż bieżąca godzina
  if (selectedDate.isSame(now, 'day') && selectedTime.isBefore(now)) {
    this.$toast.add({
      severity: 'error',
      summary: 'Błąd',
      detail: 'Nie można ustawić treningu na godzinę w przeszłości.',
      life: 3000
    });
    return; // Zatrzymaj funkcję, jeśli godzina jest niepoprawna
  }



      const treningMoment = moment(this.trening.godzina, 'HH:mm');
    const roundedMinutes = Math.round(treningMoment.minute() / 5) * 5;
    const formattedTime = treningMoment.minute(roundedMinutes).format('HH:mm');


    const treningData = {
        nazwa: this.trening.nazwa,
        data: moment(this.trening.data).format('YYYY-MM-DD'),
        godzina: formattedTime,
        grupa_treningowa_id: this.trening.grupaTreningowaId,
        cwiczenia: this.wybraneCwiczenia,
    };
    axios.post('http://127.0.0.1:8000/api/trening', treningData)
        .then(response => {
            this.$toast.add({severity: 'success', summary: 'Trening stworzony', detail: 'Trening został pomyślnie utworzony', life: 3000});
            // Możesz dodać tutaj logikę nawigacji po pomyślnym utworzeniu treningu, np. przekierowanie
        })
        .catch(error => {
            if (error.response && error.response.status === 409) {
                if (error.response.data.error === 'Ta grupa ma już zaplanowany trening na ten dzień.') {
                    this.$toast.add({severity: 'error', summary: 'Błąd', detail: 'Ta grupa ma już zaplanowany trening na ten dzień.', life: 5000});
                } else {
                    this.$toast.add({severity: 'error', summary: 'Błąd', detail: 'Konflikt terminów. Trener ma już zaplanowany trening w wybranym terminie.', life: 5000});
                }
            } else {
                this.$toast.add({severity: 'error', summary: 'Błąd', detail: 'Wystąpił błąd podczas tworzenia treningu.', life: 5000});
            }
        });
},


 
        wybierzPlan(planId) {
    // Załóżmy, że 'plany' to lista wszystkich dostępnych planów, a każdy plan zawiera listę ID ćwiczeń
    const wybranyPlan = this.plany.find(plan => plan.id === planId);
    if (wybranyPlan && wybranyPlan.cwiczenia) {
      // Resetuj wybrane ćwiczenia
      this.wybraneCwiczenia = [];

      // Iteruj przez ćwiczenia w wybranym planie i zaznacz je jako wybrane
      wybranyPlan.cwiczenia.forEach(cwiczenie => {
        this.wybraneCwiczenia.push(cwiczenie.id);
      });
    }
  },



    },
  };
  </script>
  