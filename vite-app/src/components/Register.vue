<template>
  <div class="container">
    <h2>Rejestracja</h2>
    <form @submit.prevent="register"  class="form">
      <div class="form-group">
        <label for="imie"  class="form-label">Imię</label>
        <InputText id="imie" v-model="imie" type="text" placeholder="Imię" required @blur="formatName('imie')" @keypress="validateInput"/>
      </div>
      <div class="form-group">
        <label for="nazwisko"  class="form-label">Nazwisko</label>
        <InputText id="nazwisko" v-model="nazwisko" type="text" placeholder="Nazwisko" required @blur="formatName('nazwisko')" @keypress="validateInput"/>
      </div>
      <div class="form-group">
        <label for="email"  class="form-label">Email</label>
        <InputText id="email" v-model="email" type="email" placeholder="Email" required/>
      </div>
      <div class="form-group">
        <label for="group"  class="form-label">Grupa</label>
        <Dropdown id="group" v-model="selectedGroup" :options="groups" optionLabel="nazwa" placeholder="Wybierz grupę" />
      </div>
      <Button type="submit">Zarejestruj się</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';
import InputText from 'primevue/inputtext';
import Button from 'primevue/button';
import Dropdown from 'primevue/dropdown';

export default {
  components: {
    InputText,
    Button,
    Dropdown
  },
  data() {
    return {
      imie: '',
      nazwisko: '',
      email: '',
      groups: [],
      selectedGroup: null,
      showSuccessMessage: false,
      successMessage: '',
      failedMessage:'',
      showFailedMessage: false,
    };
  },
  created() {
    this.fetchGroups();
  },
  methods: {
    async fetchGroups() {
    try {
          const response = await axios.get('http://127.0.0.1:8000/api/grupy-treningowe');
          this.groups = response.data.grupy;
        } catch (error) {
          console.error(error);
        }
      },
    async register() {

      console.log("Registering:", this.imie, this.nazwisko, this.email, this.selectedGroup);

      try {
        const selectedGroupName = this.selectedGroup ? this.selectedGroup.nazwa : null; // Pobierz nazwę grupy z obiektu
        await axios.post('http://127.0.0.1:8000/api/create-user', {
          imie: this.imie,
          nazwisko: this.nazwisko,
          email: this.email,
          grupa: selectedGroupName,
        });
        this.$toast.add({ severity: 'success', summary: 'Rejestracja', detail: 'Rejestracja przebiegła pomyślnie!', life: 3000 });
        this.resetForm();
      } catch (error) {
          let detailMessage = 'Rejestracja nie powiodła się.';
          if (error.response && error.response.data.errors) {
            const errors = error.response.data.errors;
            if (errors.grupa) {
              detailMessage = 'Proszę wybrać grupę.';
            }
          }
          this.$toast.add({ severity: 'error', summary: 'Rejestracja', detail: detailMessage, life: 3000 });
        }
      },

    resetForm() {
      this.imie = '';
      this.nazwisko = '';
      this.email = '';
      this.selectedGroup = null;
    },

    validateInput(event) {
      // Allow only letters, spaces, and hyphens
      if (!/[a-zA-ZąęłńóśżźĄĘŁŃÓŚŻŹ]/.test(event.key)) {
        event.preventDefault();
      }
    },
    formatName(fieldName) {
      if (fieldName === 'imie') {
        this.imie = this.capitalize(this.imie);
      } else if (fieldName === 'nazwisko') {
        this.nazwisko = this.capitalize(this.nazwisko);
      }
    },
    capitalize(str) {
      if (!str) return '';
      return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
    },

  }
};


</script>

<style scoped>


.container{
  margin:auto;
  width: 300px;
  padding: 20px;
  border: 2px solid #ccc;
  border-radius: 5px;
  background-color: #f5f5f5;
  text-align: left;
  background-color: rgba(255, 255, 255, 0.5);
  border-color: black ;
  border-radius: 30px;
}

.container h2{
  text-align: center;
}

.form {
  display: flex;
  flex-direction: column;
}

.form-group {
  margin-bottom: 15px;
}

.form-label {
  display: block;
  margin-bottom: 5px;
  text-align: left;
  font-weight: bold; 
  font-size: 1.1em; 
}

.success-message {
  color: green;
  background-color: lightgreen;
  padding: 10px;
  margin-top: 10px;
  border-radius: 5px;
  text-align: center;
}

.failed-message {
  color: rgba(255, 0, 0, 0.736);
  background-color: rgb(246, 244, 243);
  padding: 10px;
  margin-top: 10px;
  border-radius: 5px;
  text-align: center;
}

button{
  background-color: rgb(47, 47, 41);
}
</style>
