<template>
    <div class="create-exercise-container">
      <h1>Tworzenie nowego ćwiczenia</h1>
      <form @submit.prevent="submitForm" class="create-exercise-form">
        <div class="form-group">
          <label for="nazwa">Nazwa</label>
          <InputText id="nazwa" v-model="form.nazwa" placeholder="Nazwa ćwiczenia" />
        </div>
        <div class="form-group">
          <label for="opis">Opis</label>
          <Textarea id="opis" v-model="form.opis" rows="5" placeholder="Opis ćwiczenia" class="textarea-input" />
        </div>
        <div class="form-group">
          <label for="rodzaj">Rodzaj</label>
          <MultiSelect id="rodzaj" v-model="form.rodzaj" :options="rodzaje" optionLabel="name" placeholder="Wybierz rodzaje" :selectionLimit="3" />
        </div>
            <div class="form-group">
                <label for="film">Film</label>
                <input id="film" type="file" @change="handleFileUpload($event, 'film')" class="file-input">
            </div>
            <div class="form-group">
                <label for="zdjecie">Zdjęcie</label>
                <input id="zdjecie" type="file" @change="handleFileUpload($event, 'zdjecie')" class="file-input">
            </div>
            <Button type="submit" label="Utwórz ćwiczenie" />
        </form>
    </div>
</template>

<script>
import InputText from 'primevue/inputtext';
import Textarea from 'primevue/textarea';
import MultiSelect from 'primevue/multiselect';
import Button from 'primevue/button';
import axios from 'axios';



export default {
    components: {
        InputText,
        Textarea,
        MultiSelect,
        Button
    },
    data() {
        return {
            form: {
                nazwa: '',
                opis: '',
                rodzaj: [],
                film: null,
                zdjecie: null,
            },
            rodzaje: [
                { name: 'Siła', code: 'sila' },
                { name: 'Wytrzymałość', code: 'wytrzymalosc' },
                { name: 'Reakcje', code: 'reakcje' },
                { name: 'Strzały', code: 'strzaly' },
                { name: 'Podania', code: 'podania' },
                { name: 'Stałe fragmenty', code: 'stale_fragmenty' },
                // Dodaj więcej rodzajów zgodnie z potrzebami
            ]
        };
    },
    methods: {
        submitForm() {
            let formData = new FormData();
            formData.append('nazwa', this.form.nazwa);
            formData.append('opis', this.form.opis);
            this.form.rodzaj.forEach(rodzaj => formData.append('rodzaj[]', rodzaj.code)); // Przekazanie wielu rodzajów
            if (this.form.film) formData.append('film', this.form.film);
            if (this.form.zdjecie) formData.append('zdjecie', this.form.zdjecie);

            axios.post('http://127.0.0.1:8000/api/cwiczenia', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(response => {
                this.resetForm();
                this.$toast.add({severity:'success', summary: 'Sukces', detail: 'Ćwiczenie dodane pomyślnie', life: 3000});
                console.log(response.data);
            }).catch(error => {
                // Obsługa błędu
                console.error(error.response.data);
            });
        },
        handleFileUpload(event, type) {
            if (type === 'film') {
                const file = event.target.files[0];
                const maxDuration = 120; 
                if (file) {
                    // Tworzenie obiektu URL dla pliku
                    const url = URL.createObjectURL(file);
                    // Wczytywanie pliku jako elementu wideo
                    const video = document.createElement('video');
                    video.src = url;
                    video.onloadedmetadata = () => {
                        // Sprawdzenie, czy długość filmu przekracza maksymalną wartość
                        if (video.duration > maxDuration) {
                            this.$toast.add({
                                severity: 'error',
                                summary: 'Błąd',
                                detail: 'Film nie może być dłuższy niż 5 minut.',
                                life: 3000
                            });
                            // Reset inputa, jeśli film jest za długi
                            event.target.value = '';
                        } else {
                            // Akceptacja pliku, jeśli spełnia kryteria
                            this.form[type] = file;
                            this.$toast.add({
                                severity: 'success',
                                summary: 'Udalo sie',
                                detail: 'Film spelnia wymogi i moze zostac dodany.',
                                life: 3000
                            });
                        }
                    };
                }
            } else if (type === 'zdjecie') {
                this.form[type] = event.target.files[0];
            }
        },

        resetForm() {
     this.form = {
        nazwa: '',
        opis: '',
        rodzaj: [],
        film: null,
        zdjecie: null,
    };
},


    },
};
</script>
<style scoped>
.create-exercise-container {
    max-width: 600px;
    margin: auto;
    padding: 20px;
    background-color: #f5f5f5;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
}

h1 {
    font-size: 24px; /* Zmniejszenie rozmiaru czcionki dla nagłówka */
    text-align: center;
    margin-bottom: 20px;
}

.create-exercise-form .form-group {
    margin-bottom: 15px;
    display: flex;
    flex-direction: column;
}

.form-group label {
    margin-bottom: 5px;
    font-weight: bold;
}

 .file-input {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    border-radius: 5px;
    border: 1px solid #000; /* Zmiana koloru ramki na czarny */
}

.textarea-input {
    resize: none; /* Zapobiega rozciąganiu się textarea */
    height: 100px; /* Ustaw wysokość, aby uniknąć rozciągania w pionie */
    width: 100%; /* Ustaw szerokość, aby uniknąć rozciągania w poziomie */
    padding: 10px;
    margin-top: 5px;
    border-radius: 5px;
    border: 1px solid #000;
   
}

button{
  background-color: rgb(47, 47, 41);
}
</style>
