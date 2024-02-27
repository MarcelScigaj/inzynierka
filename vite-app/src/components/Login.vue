<template>
  <div class="login-container">
    
    <form @submit.prevent="performLogin" class="login-form">
      <div class="form-group">
        <label for="login">Login</label>
        <input v-model="login" type="text" id="login" placeholder="Login" class="text-input">
      </div>
      <div class="form-group">
        <label for="haslo">Hasło</label>
        <input v-model="haslo" type="password" id="haslo" placeholder="Hasło" class="text-input">
      </div>
      <button type="submit" class="submit-button">Zaloguj się</button>
    </form>
    
  </div>
</template>

<script>
import axios from 'axios';


export default {
  data() {
    return {
      login: '',
      haslo: '',
      
    };
  },
  methods: {
    async performLogin() {
      try {
        
        const response = await axios.post('http://127.0.0.1:8000/api/login', {
          login: this.login,
          haslo: this.haslo
        });

        localStorage.setItem('authToken', response.data.token);
        localStorage.setItem('userData', JSON.stringify(response.data.user));
        localStorage.setItem('userRole', JSON.stringify(response.data.role.split(/,\s*/)));



        this.$root.isLoggedIn = true;
        this.$root.userName = response.data.user.imie;

        this.$emit('logged-in');


        this.$toast.add({severity: 'success', summary: 'Zalogowano', detail: 'Zalogowano pomyślnie!', life: 3000});

        this.$router.push('/home');
        
      } catch (error) {
        if (error.response && error.response.data) {
          this.$toast.add({severity: 'error', summary: 'Błąd logowania', detail: 'Nie udało się zalogować.', life: 3000});
        } else {
          
          console.error("Błąd sieci lub serwera:", error);
        }
      }
    }
  }
};
</script>

<style scoped>
/* Styl dla formularza logowania */
.login-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 50vh;
}

.login-header {
  margin-bottom: 20px;
}

.login-form {
  width: 300px;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  background-color: #f5f5f5;
  text-align: center;
  background-color: rgba(255, 255, 255, 0.5);
}

.form-group {
  margin-bottom: 15px;
  
}

label {
  display: block;
  margin-bottom: 5px;
}

.text-input {
  width: 80%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  text-align: center;
  background-color: rgba(255, 255, 255, 0.7);
}

.submit-button {
  width: 100%;
  padding: 10px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin: 0 auto;
}

.submit-button:hover {
  background-color: #0056b3;
}
</style>
