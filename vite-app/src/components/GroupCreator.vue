<template>
    <div>
      <h2>Stwórz Grupę Treningową</h2>
      <form @submit.prevent="createGrupaTreningowa">
        <div>
          <label for="nazwa">Nazwa Grupy</label>
          <input id="nazwa" v-model="nazwa" type="text" placeholder="Nazwa Grupy">
        </div>
        <div>
          <label for="trener">Trener</label>
          <select id="trener" v-model="trener_id">
            <option v-for="trener in trenerzy" :key="trener.id" :value="trener.id">{{ trener.imie }} {{ trener.nazwisko }}</option>
          </select>
        </div>
        <button type="submit">Utwórz Grupę</button>
      </form>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        nazwa: '',
        trener_id: null,
        trenerzy: [], // Załaduj listę trenerów z API
      };
    },
    methods: {
      async createGrupaTreningowa() {
        // Wykonaj żądanie do API, aby stworzyć grupę treningową
      }
    },
    created() {
      this.fetchTrenerzy(); // Załaduj trenerów podczas tworzenia komponentu
    },
    // Metoda do ładowania trenerów z API
  };
  </script>
  