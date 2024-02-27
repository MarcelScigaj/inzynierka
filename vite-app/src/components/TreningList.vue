
<template>

   <!--DODAC PRZYCISK I POPRAWIC BLEDY Z KONSOLI KTORE SA !-->
  <div class="container">
    
    <div>
      <label class="label" for="filtr-data">Filtruj po dacie:</label>
      <Calendar v-model="filtrData" @update:modelValue="fetchTreningi" showButtonBar selectionMode="range"  dateFormat="yy-mm-dd"></Calendar>
      
    </div>
    
    <DataTable  class="tabela" :value="treningi" dataKey="id" paginator :rows="5" tableStyle="width: 50rem"> <!-- -->
      <template #empty>
        <tr>
          <td colspan="100%" class="empty-message">Brak treningów w tym terminie</td>
        </tr>
      </template>
      <Column field="nazwa" header="Nazwa"></Column>
      <Column field="data" header="Data"></Column>
      <Column field="godzina" header="Godzina">
        <template #body="slotProps">
          {{ moment(slotProps.data.godzina, 'HH:mm:ss').format('HH:mm') }}
        </template>
      </Column>
      <Column field="grupa_treningowa_id" header="Grupa Treningowa">
        <template #body="slotProps">
            <div v-if="!isLoadingGrupyTreningowe">
              {{ znajdzNazweGrupy(slotProps.data.grupa_treningowa_id) }}
            </div>
            <div v-else>
              Dane o grupach są ładowane...
            </div>
        </template>
      </Column>
      <Column header="Akcje">
        <template #body="slotProps">
          <Button icon="pi pi-pencil" @click="edytujTrening(slotProps.data)" class="p-button-rounded p-button-success" v-if="mozeEdytowac(slotProps.data)"></Button>
          <Button icon="pi pi-trash" @click="usunTrening(slotProps.data.id)" class="p-button-rounded p-button-danger" v-if="mozeEdytowac(slotProps.data)"></Button>
        </template>
      </Column>
    </DataTable>

    <Dialog v-model="showEditDialog" header="Edytuj trening" :visible.sync="showEditDialog"  :dismissableMask="true">
      <template #closeicon>
      <button @click="hideDialog" class="custom-close-button">X</button> <!--:modal="true"-->
      </template>
      <InputText v-model="editableTrening.nazwa" placeholder="Nazwa Treningu" />
      <Calendar v-model="editableTrening.data" :showIcon="true" dataType="date" placeholder="Wybierz datę" />
      <Calendar v-model="editableTrening.godzina" :showIcon="true" timeOnly hourFormat="24"  placeholder="Wybierz godzinę"  :stepMinute="5"/>

      <div class="p-field">
        <label id="text-field">Ćwiczenia:</label>
        <div style="height: 150px; overflow-y: auto; border: 1px solid #ddd; padding: 5px;">
          <div v-for="cwiczenie in wszystkieCwiczenia" :key="cwiczenie.id">
            <Checkbox :value="cwiczenie.id" v-model="cwiczenie.zaznaczone" binary :inputId="'checkbox' + cwiczenie.id" />
            <label id="text-field" :for="'checkbox' + cwiczenie.id">{{ cwiczenie.nazwa }}</label>
          </div>
        </div>
      </div>
      <Button label="Zapisz zmiany" @click="updateTrening" ></Button>
    </Dialog>
  </div>
</template>

<script>
import axios from 'axios';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import Button from 'primevue/button';
import Calendar from 'primevue/calendar';
import Dialog from 'primevue/dialog';
import moment from 'moment';
import InputText from 'primevue/inputtext';
import ScrollPanel from 'primevue/scrollpanel';
import Checkbox from 'primevue/checkbox';

export default {
  components: {
    DataTable,
    Column,
    Button,
    Calendar,
    Dialog,
    InputText,
    ScrollPanel,
    Checkbox
  },
  data() {
    return {
      treningi: [],
      filtrData: '',
      userData: JSON.parse(localStorage.getItem('userData')) || {},
      grupyTreningowe: [],
      isLoadingGrupyTreningowe: true,
      showEditDialog: false,
      editableTrening: {
        nazwa: '',
        data: '',
        godzina: '',
        grupa_treningowa_id: null,
        cwiczenia: [],
      },
      wszystkieCwiczenia:[],
      selectedCwiczenia: [],
    };
  },
  created() {
    this.fetchTreningi();
    this.fetchGrupyTreningowe();
    this.fetchCwiczenia();
  },
  methods: {
    fetchTreningi() {
      console.log('fetchTreningi is called');
      let params = {};
      if (this.filtrData && this.filtrData.length === 1) {
        const date = moment(this.filtrData[0]).format('YYYY-MM-DD');
        params.startDate = date;
        params.endDate = date;
      }else if (this.filtrData && this.filtrData.length > 1){
        const startDate = moment(this.filtrData[0]).format('YYYY-MM-DD');
        const endDate = moment(this.filtrData[1]).format('YYYY-MM-DD');
        params.startDate = startDate;
        params.endDate = endDate;
      }
      console.log(params);
      axios.get('http://127.0.0.1:8000/api/treningi', { params })
        .then(response => {
          this.treningi = response.data;
          console.log(response.data);
        })
        .catch(error => {
          console.error("Błąd podczas pobierania treningów: ", error);
        });
    },
    
    async usunTrening(treningId) {
    try {
      await axios.delete(`http://127.0.0.1:8000/api/trening/${treningId}`, {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('authToken')}`
        }
      });
      this.fetchTreningi(); // Odświeżenie listy treningów
      // Wyświetl komunikat o sukcesie
    } catch (error) {
      // Obsługa błędów
    }
  },


  async updateTrening() {
    

    const selectedDate = moment(this.editableTrening.data);
  const selectedTime = moment(this.editableTrening.godzina, 'HH:mm');
  const now = moment();

  if (selectedDate.isSameOrBefore(now, 'day') && (selectedDate.isSame(now, 'day') && selectedTime.isBefore(now))) {
    this.$toast.add({
      severity: 'error',
      summary: 'Błąd',
      detail: 'Nie można ustawić treningu na datę i godzinę w przeszłości.',
      life: 3000
    });
    return; // Zatrzymaj funkcję, jeśli data lub godzina są niepoprawne
  }


    const treningMoment = moment(this.editableTrening.godzina, 'HH:mm');
    const roundedMinutes = Math.round(treningMoment.minute() / 5) * 5;
    const formattedTime = treningMoment.minute(roundedMinutes).format('HH:mm');

    const updatedTreningData = {
    nazwa: this.editableTrening.nazwa,
    data: moment(this.editableTrening.data).format('YYYY-MM-DD'),
    godzina: formattedTime,
    grupa_treningowa_id: this.editableTrening.grupa_treningowa_id,
    cwiczenia: this.wszystkieCwiczenia.filter(c => c.zaznaczone).map(c => c.id), // Użycie zaktualizowanej listy wybranych ćwiczeń
  };

  try {
    console.log(updatedTreningData);
    await axios.put(`http://127.0.0.1:8000/api/trening/${this.editableTrening.id}`, updatedTreningData, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      }
    });
    this.$toast.add({severity: 'success', summary: 'Sukces', detail: 'Trening został zaktualizowany.', life: 3000});
    this.showEditDialog = false;
    this.fetchTreningi();
  } catch (error) {
    console.error("Błąd podczas aktualizacji treningu:", error);
    this.$toast.add({severity: 'error', summary: 'Błąd', detail: 'Nie udało się zaktualizować treningu.', life: 5000});
  }
},




mozeEdytowac(trening) {
  const userRole = localStorage.getItem('userRole');
  const userData = JSON.parse(localStorage.getItem('userData'));
  return userRole === 'ADMIN' || trening.uzytkownik_id === userData.id;
},

    async fetchGrupyTreningowe() {
  this.isLoadingGrupyTreningowe = true; // Rozpoczęcie ładowania
  try {
    const response = await axios.get('http://127.0.0.1:8000/api/grupy-treningowe');
    this.grupyTreningowe = response.data.grupy || [];
  } catch (error) {
    console.error("Błąd podczas pobierania grup treningowych: ", error);
  } finally {
    this.isLoadingGrupyTreningowe = false; // Zakończenie ładowania
  }
},

znajdzNazweGrupy(grupaId) {
  if (this.isLoadingGrupyTreningowe) {
    return 'Dane o grupach są ładowane...'; // Pokaż ten tekst, gdy dane są ładowane
  }
  const grupa = this.grupyTreningowe.find(grupa => grupa.id === grupaId);
  return grupa ? grupa.nazwa : 'Nieznana grupa';
},
  moment(...args) {
    return moment(...args);
  },

  fetchCwiczenia() {
  axios.get('http://127.0.0.1:8000/api/cwiczenia')
    .then(response => {
      // Inicjalizacja każdego ćwiczenia ze stanem zaznaczenia
      this.wszystkieCwiczenia = response.data.map(cwiczenie => ({
        ...cwiczenie,
        zaznaczone: false, // Domyślnie wszystkie ćwiczenia są niezaznaczone
      }));
    })
    .catch(error => console.error("Błąd podczas pobierania ćwiczeń:", error));
},


edytujTrening(trening) {
  this.editableTrening = { ...trening };
  // Ustawienie stanu zaznaczenia na podstawie tego, co było wcześniej zapisane w treningu
  this.wszystkieCwiczenia.forEach(cwiczenie => {
    cwiczenie.zaznaczone = trening.cwiczenia.some(tc => tc.id === cwiczenie.id);
  });
  this.showEditDialog = true;
},
  
 hideDialog(){
  this.showEditDialog = false;
 }

  }
};
</script>

<style scoped>

.container{
  padding-top: 1%;
  background-color: rgba(47, 47, 41, 0.8) !important;
}

button {
  background-color: rgb(47, 47, 41);
  margin-left: 5px;
}
.empty-message {
  text-align: center;
  font-weight: bold;
  color: #999999;
}

.label{
  font-weight: bold;
  color: white;
  margin-right: 5px;
}
  .tabela{
    margin-top: 10px;
  
}

#text-field{
  color: #ffff;
  
}

.p-button{
  margin-top:10px;
}


</style>
