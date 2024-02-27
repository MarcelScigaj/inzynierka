<template>
    <div class="container">
      <h1>Tworzenie Nowego Planu</h1>
      <input v-model="nazwaPlanu" placeholder="Nazwa Planu">
      <div v-for="cwiczenie in cwiczenia" :key="cwiczenie.id">
        <label>
          <input type="checkbox" :value="cwiczenie.id" v-model="wybraneCwiczenia">
          {{ cwiczenie.nazwa }}
        </label>
      </div>
      <button @click="zapiszPlan">Zapisz Plan</button>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        cwiczenia: [],
        nazwaPlanu: '',
        wybraneCwiczenia: []
      };
    },
    created() {
      this.pobierzCwiczenia();
    },
    methods: {
      pobierzCwiczenia() {
        axios.get('http://127.0.0.1:8000/api/cwiczenia')
          .then(response => {
            this.cwiczenia = response.data;
          })
          .catch(error => console.error("Błąd przy pobieraniu ćwiczeń:", error));
      },
      zapiszPlan() {
        axios.post('http://127.0.0.1:8000/api/gotowy-plan', {
          nazwa: this.nazwaPlanu,
          opis: this.opisPlanu,
          cwiczenia: this.wybraneCwiczenia
        })
        .then(response => alert('Plan zapisany pomyślnie'))
        .catch(error => console.error("Błąd przy zapisywaniu planu:", error));
      }
    }
  };
  </script>

  <style scoped>
  .container{
    background-color: rgba(255, 255, 255, 0.8);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 50vh;
    
  }
</style>
  