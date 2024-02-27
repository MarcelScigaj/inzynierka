<template>
    <div>
      <h2>Wybierz grupę treningową</h2>
      <DataTable :value="grupyTreningowe" @row-dblclick="onRowDoubleClick" dataKey="id">
        <Column field="nazwa" header="Nazwa grupy"></Column>
        <!-- Możesz dodać więcej kolumn jeśli potrzebujesz -->
      </DataTable>
    </div>
  </template>
  
  <script>
  import  DataTable  from 'primevue/datatable';
  import  Column  from 'primevue/column';
  import axios from 'axios';
  
  export default {
    components: {
      DataTable,
      Column,
    },
    data() {
      return {
        grupyTreningowe: [],
      };
    },
    created() {
      this.fetchGrupyTreningowe();
    },
    methods: {
      fetchGrupyTreningowe() {
        axios
          .get('http://127.0.0.1:8000/api/trener-grupy')
          .then((response) => {
            this.grupyTreningowe = response.data;
          })
          .catch((error) => console.error("Błąd podczas pobierania grup treningowych: ", error));
      },
      onRowDoubleClick(event) {
        this.$router.push({ name: 'TreningForm', params: { grupaTreningowaId: event.data.id }});
      },
    },
  };
  </script>
  