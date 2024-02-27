<template>
  <div class="main-container">
    <div class="v-calendar-container">
      <VCalendar class="my-calendar"  :attributes="prepareCalendarAttributes()" />
    </div>
    <div class="chat-container">
      <ChatView/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import VCalendar from 'v-calendar';
import ChatView from './ChatView.vue';

export default {
  name: 'Home',
  components: {
    ChatView
  },
  data() {
    return {
      userId: JSON.parse(localStorage.getItem('userData')).id, // ID zalogowanego użytkownika
      userRole: JSON.parse(localStorage.getItem('userRole')),
 // Rola zalogowanego użytkownika
      treningi: [],
      grupyTreningowe: [],
      grupyTreningoweUzytkownika: [], // Grupy, do których należy zalogowany użytkownik
    };
  },
  created() {
    this.fetchGrupyTreningoweUzytkownika().then(() => {
      this.fetchTreningi();
      this.fetchGrupyTreningowe();
    });
  },
  methods: {
    async fetchGrupyTreningoweUzytkownika() {
      const url = this.userRole.includes('dziecko') ?
              `http://127.0.0.1:8000/api/uzytkownik-grupy/${this.userId}` :
              `http://127.0.0.1:8000/api/rodzic-grupy/${this.userId}`;
  try {
    const response = await axios.get(url);
    if (this.userRole === 'rodzic') {
      // Przyjmujemy, że odpowiedź dla rodzica jest już poprawna i zawiera tylko ID grup
      this.grupyTreningoweUzytkownika = response.data.grupy.map(grupa => grupa.id);
    } else {
      this.grupyTreningoweUzytkownika = response.data.grupy.map(grupa => grupa.id);
    }
  } catch (error) {
    console.error("Błąd podczas pobierania grup użytkownika: ", error);
  }
},


    async fetchTreningi() {
      try {
        const response = await axios.get('http://127.0.0.1:8000/api/treningi');
        if (this.userRole.includes('Trener')) {
          this.treningi = response.data.filter(trening => trening.uzytkownik_id === this.userId);
        } else  {
          this.treningi = response.data.filter(trening => this.grupyTreningoweUzytkownika.includes(trening.grupa_treningowa_id));
        }
        this.prepareCalendarAttributes();
      } catch (error) {
        console.error("Błąd podczas pobierania treningów: ", error);
      }
    },
    fetchGrupyTreningowe() {
      axios.get('http://127.0.0.1:8000/api/grupy-treningowe')
        .then(response => {
          this.grupyTreningowe = response.data;
        })
        .catch(error => {
          console.error("Błąd podczas pobierania grup treningowych: ", error);
        });
    },

prepareCalendarAttributes() {
  if (!this.treningi.length) {
    return [];
  }

  // Przykładowa paleta kolorów dla treningów w danym dniu
  const palette = ['blue', 'red', 'green'];

  // Grupowanie treningów według daty
  const treningiPoDacie = this.treningi.reduce((acc, trening) => {
    const data = trening.data;
    if (!acc[data]) {
      acc[data] = [];
    }
    acc[data].push(trening);
    return acc;
  }, {});

  // Przygotowanie atrybutów z uwzględnieniem liczby treningów w danym dniu
  let attributes = [];
  Object.keys(treningiPoDacie).forEach(data => {
    treningiPoDacie[data].forEach((trening, index) => {
      const nazwaGrupy = trening.grupa_treningowa ? trening.grupa_treningowa.nazwa : 'Nieznana grupa';
      const dotColor = palette[index % palette.length]; // Cykliczne przypisywanie kolorów z palety

      attributes.push({
        key: `${trening.id}-${data}`,
        dot: { color: dotColor },
        dates: new Date(data),
        popover: { label: `${trening.nazwa}, ${nazwaGrupy}` },
      });
    });
  });

  return attributes;
},
    znajdzNazweGrupy(grupaId) {
      // Zakładając, że grupyTreningowe są już wcześniej załadowane lub dostępne
      const grupa = this.grupyTreningowe.find(grupa => grupa.id === grupaId);
      return grupa ? grupa.nazwa : 'Nieznana grupa';
    }
  }
};
</script>
<style scoped>
.my-calendar .vc-weekday-1, .my-calendar .vc-weekday-7 {
  color: #6366f1;
}

.main-container {
  display: flex;
  height: 100%;
  justify-content: space-between; /* Rozmieszcza elementy na krawędziach */
}

.v-calendar-container,
.chat-container {
  margin: 10px; /* Dodaje odstęp wokół kontenerów */
  flex-grow: 1; /* Zapewnia, że kontenery zajmują dostępną przestrzeń */
}

</style>
