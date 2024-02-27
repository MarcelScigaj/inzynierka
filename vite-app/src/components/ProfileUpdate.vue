<template>
  <div class="profile-update-container">
    <h2>Uzupełnij swój profil</h2>
    <form @submit.prevent="completeProfile" class="form">
      <div class="form-group">
        <label for="login"  class="form-label">Login:</label>
        <InputText v-model="profile.login" id="login" />
      </div>
      <div class="form-group">
      <label for="haslo"  class="form-label">Hasło:</label>
      <Password v-model="profile.haslo" id="haslo" @input="validatePassword">
        <template #header>
          <h6>Wybierz hasło</h6>
        </template>
        <template #footer>
          <Divider />
          <p class="mt-2">Sugestie</p>
          <ul class="pl-2 ml-2 mt-0" style="line-height: 1.5">
            <li :class="{ 'valid': passwordCriteria.lowercase }">Co najmniej jedna mała litera</li>
            <li :class="{ 'valid': passwordCriteria.uppercase }">Co najmniej jedna duża litera</li>
            <li :class="{ 'valid': passwordCriteria.digit }">Co najmniej jedna cyfra</li>
            <li :class="{ 'valid': passwordCriteria.minChars }">Minimum 8 znaków</li>
          </ul>
        </template>
      </Password>
    </div>
      <div class="form-group">
        <label for="email"  class="form-label">Email:</label>
        <InputText v-model="profile.email" id="email" type="email" />
      </div>
      <div class="form-group">
        <label for="tel"  class="form-label" >Nr Telefonu:</label>
        <InputText v-model="profile.telefon" id="tel" type="tel" @keypress="validatePhoneNumber" maxlength="9" />
      </div>
      <div class="form-group">
        <label for="imie" class="form-label">Imię:</label>
        <InputText v-model="profile.imie" id="imie" @keypress="validateInput" @blur="formatName('imie')" />
      </div>
      <div class="form-group">
        <label for="nazwisko" class="form-label">Nazwisko:</label>
        <InputText v-model="profile.nazwisko" id="nazwisko" @keypress="validateInput" @blur="formatName('nazwisko')" />
      </div>
      
  <div class="form-group">
    <label for="avatar">Awatar:</label><br>
    <button type="button" @click="triggerFileInput" class="file-upload-btn">{{ fileName  }}</button>
    <input type="file" id="avatar" ref="fileInput" @change="handleFileUpload" style="display: none;">
  </div>

  <button type="button" @click="completeProfile" class="submit-button">Zapisz zmiany</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';
import InputText from 'primevue/inputtext';
import Password from 'primevue/password';
import Button from 'primevue/button';
import Divider from 'primevue/divider';
//import Toast from 'primevue/toast';

export default {
  components: {
    InputText,
    Password,
    Button,
    Divider,
  },
  data() {
    return {
      profile: {
        login: '',
        haslo: '',
        telefon: '',
        email: '',
        imie: '',
        nazwisko: '',
      },
      passwordCriteria: { 
        lowercase: false,
        uppercase: false,
        digit: false,
        minChars: false,
      },
      avatarFile: null,
      fileName: 'Wybierz plik',
      
    };
  },
  mounted() {
    this.fetchUserData();
  },
  methods: {

    validatePhoneNumber(event) {
      // Allow only digits
      if (!/[0-9]/.test(event.key)) {
        event.preventDefault();
      }
    },
    validateInput(event) {
      if (!/[a-zA-ZąęłńóśżźĄĘŁŃÓŚŻŹ]/.test(event.key)) {
        event.preventDefault();
      }
    },
    formatName(fieldName) {
      if (fieldName === 'imie') {
        this.profile.imie = this.capitalize(this.profile.imie);
      } else if (fieldName === 'nazwisko') {
        this.profile.nazwisko = this.capitalize(this.profile.nazwisko);
      }
    },
    capitalize(str) {
      return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
    },

    triggerFileInput() {
      this.$refs.fileInput.click();
    },
    handleFileUpload(event) {
      const file = event.target.files[0];
      if (file) {
        this.avatarFile = file;
        this.fileName = "Wczytano zdjęcie"; 
      }
    },
    completeProfile() {
      const formData = new FormData();
      Object.keys(this.profile).forEach(key => {
        formData.append(key, this.profile[key]);
      });
      if (this.avatarFile) {
        formData.append('avatar', this.avatarFile);
      }

      formData.append('_method', 'PUT');

      axios.post('http://127.0.0.1:8000/api/update-profile', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': `Bearer ${localStorage.getItem('authToken')}`,
        },
      }).then(() => {
        this.$toast.add({severity: 'success', summary: 'Profil zaktualizowany', detail: 'Twój profil został pomyślnie zaktualizowany.'});
        this.$router.push('/');
      }).catch(error => {
  if (error.response && error.response.status === 422 && error.response.data.errors) {
    Object.keys(error.response.data.errors).forEach(key => {
      const message = error.response.data.errors[key][0]; // Pobiera pierwszy komunikat błędu dla każdego pola
      this.$toast.add({severity: 'error', summary: 'Błąd walidacji', detail: message});
    });
  } else {
    console.error('Wystąpił błąd podczas aktualizacji profilu: ', error);
    this.$toast.add({severity: 'error', summary: 'Błąd aktualizacji', detail: 'Nie udało się zaktualizować profilu. Spróbuj ponownie później.'});
  }
});
    },

    
    fetchUserData() {
      axios.get('http://127.0.0.1:8000/api/user', {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('authToken')}`,
        }
      }).then(response => {
        this.profile = {
          login: response.data.login,
          email: response.data.email,
          imie: response.data.imie,
          nazwisko: response.data.nazwisko,
          telefon: response.data.telefon,
          // Nie ustawiaj hasła z oczywistych powodów bezpieczeństwa
        };
        this.avatarPreview = response.data.avatarUrl; // Jeśli serwer zwraca URL awatara
      }).catch(error => {
        console.error("Błąd przy pobieraniu danych użytkownika", error);
      });
    },
    validatePassword() {
      const password = this.profile.haslo || ''; // Zapewnia, że password jest ciągiem
      this.passwordCriteria.lowercase = /[a-z]/.test(password);
      this.passwordCriteria.uppercase = /[A-Z]/.test(password);
      this.passwordCriteria.digit = /[0-9]/.test(password);
      this.passwordCriteria.minChars = password.length >= 8;
    },
  },
  watch: {
    'profile.haslo': {
      handler(newVal) {
        if (newVal !== undefined) { // Upewnij się, że newVal jest zdefiniowane
          this.validatePassword();
        }
      },
      immediate: false, // Nie wywołuj natychmiast po załadowaniu komponentu
    },
},
};
</script>


<style scoped>
.profile-update-container {
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

.profile-update-container h2{
  text-align: center;
}

.form {
  display: flex;
  flex-direction: column;
}

.form-group {
  margin-bottom: 20px;
}



.form-label {
  display: block;
  margin-bottom: 5px;
  text-align: left;
  font-weight: bold; 
  font-size: 1.1em; 
}

.avatar-preview {
  width: 100px;
  height: 100px;
  margin-top: 10px;
}

.submit-button {
  margin-top: 20px;
}
.valid {
  color: green;
}

button{
  background-color: rgb(47, 47, 41);
  color:white;
}
</style>
