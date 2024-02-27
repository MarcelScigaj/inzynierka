<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use App\Models\User;

class TrainerCreated extends Mailable
{
    use Queueable, SerializesModels;

    public $login;
    public $password;
    public $imie;
    public $nazwisko;

    /**
     * Utwórz nową instancję wiadomości.
     *
     * @param string $imie Imię trenera.
     * @param string $nazwisko Nazwisko trenera.
     * @param string $login Login trenera.
     * @param string $password Hasło trenera.
     * @return void
     */
    public function __construct($imie, $nazwisko, $login, $password)
    {
        $this->login = $login;
        $this->password = $password;
        $this->imie = $imie;
        $this->nazwisko = $nazwisko;
    }

    /**
     * Zbuduj wiadomość.
     *
     * @return $this
     */
    public function build()
    {
        return $this->view('emails.trainerCreated')
                    ->with([
                        'login' => $this->login,
                        'password' => $this->password,
                        'imie' => $this->imie,
                        'nazwisko' => $this->nazwisko,
                    ]);
    }

     /**
     * Get the message envelope.
     *
     * @return \Illuminate\Mail\Mailables\Envelope
     */
    public function envelope()
    {
        return new Envelope(
            subject: 'Dane logowania aplikacji',
        );
    }

    /**
     * Get the message content definition.
     *
     * @return \Illuminate\Mail\Mailables\Content
     */
    public function content()
    {
        return new Content(
            view: 'emails.trainerCreated',
        );
    }

    /**
     * Get the attachments for the message.
     *
     * @return array
     */
    public function attachments()
    {
        return [];
    }

}
