<template>
    <div>
      <DataTable v-model:expandedRows="expandedRows" :value="exercises" dataKey="id" paginator :rows="5" tableStyle="width: 50rem">
        <Column expander style="width: 3em" />
        <Column field="nazwa" header="Nazwa" />
        <Column field="opis" header="Opis" />
        
        <template #expansion="slotProps">
        <div class="expanded-row-content">
          <div>
            Rodzaj: {{ slotProps.data.rodzaj }}
          </div>
          <div v-if="slotProps.data.tutorials.length">
            <h5>Tutoriale:</h5>
            <ul>
              <li v-for="tutorial in slotProps.data.tutorials" :key="tutorial.id" class="tutorial-item">
                <img :src="getFullImagePath(tutorial.sciezka_zdjecie)" alt="Zdjęcie" class="tutorial-image">
                <video controls :src="getFullVideoPath(tutorial.sciezka_film)" class="tutorial-video">
                  Twoja przeglądarka nie wspiera tagu video.
                </video>
              </li>
            </ul>
          </div>
        </div>
      </template>
    </DataTable>
  </div>
</template>
  
  <script>
  import axios from 'axios';
  import DataTable from 'primevue/datatable';
  import Column from 'primevue/column';
 import "primeicons/primeicons.css";
  
  export default {
    components: {
      DataTable,
      Column,
    },
    data() {
      return {
        exercises: [],
        expandedRows: null,
      };
    },
    created() {
      this.fetchExercises();
    },
    methods: {
      fetchExercises() {
        axios.get('http://127.0.0.1:8000/api/cwiczenia')
          .then(response => {
           
            this.exercises = response.data.map(exercise => ({
              ...exercise,
              tutorials: exercise.tutorials?.map(tutorial => ({
                ...tutorial,
                sciezka_zdjecie: tutorial.sciezka_zdjecie,
                sciezka_film: tutorial.sciezka_film,
              })) || []
            }));
          })
          .catch(error => console.error("Błąd przy pobieraniu ćwiczeń:", error));
          
      },

      getFullImagePath(path) {
        return path ? `http://127.0.0.1:8000/${path}` : '';
},
      getFullVideoPath(path) {
        return path ? `http://127.0.0.1:8000/${path}` : '';
},
    },
  };
  </script>
  

  <style scoped>
  .tutorials-container {
    display: flex;
    flex-direction: column; /* Elementy tutoriali wyświetlane pionowo */
  }
  
  .tutorial-item {
    list-style-type: none; /* Ukrywa punktor listy */
    margin-bottom: 0; /* Usuwa odstęp między elementami tutoriali */
  }
  
  .tutorial-image {
    display: block; /* Zapobiega domyślnemu marginesowi od <li> */
    max-width: 100%; /* Ogranicz maksymalną szerokość do kontenera */
    max-height: 300px; /* Ogranicz maksymalną wysokość zdjęcia */
    object-fit: cover; /* Zachowaj proporcje, nie zniekształcając obrazu */
    margin-bottom: 0;
    
  }
  
  .tutorial-video {
    max-width: 100%; /* Ogranicz maksymalną szerokość do kontenera */
    max-height: 300px; /* Ogranicz maksymalną wysokość filmiku */
  }
  
  .expanded-row-content {
  overflow-y: auto; /* Allows vertical scrolling within the expansion */
  max-height: 500px; /* Adjust based on your needs */
}

  </style>