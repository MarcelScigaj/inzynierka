<template>
    <div>
      <h1>Tworzenie konta dla trenera</h1>
      <form @submit.prevent="submitForm">
        <input v-model="form.imie" placeholder="Imię" required>
        <input v-model="form.nazwisko" placeholder="Nazwisko" required>
        <input v-model="form.email" type="email" placeholder="Email" required>
        <button type="submit">Utwórz konto</button>
      </form>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        form: {
          imie: '',
          nazwisko: '',
          email: '',
        },
      };
    },
    methods: {
      submitForm() {
        axios.post('http://127.0.0.1:8000/api/create-trainer', this.form)
          .then(response => {
            alert('Konto trenera utworzone pomyślnie.');
            // Przekierowanie lub czyszczenie formularza
          })
          .catch(error => {
            console.error('Wystąpił błąd przy tworzeniu konta trenera.', error);
          });
      }
    }
  };
  </script>
  