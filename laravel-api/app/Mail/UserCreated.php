<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;
use App\Models\User;

class UserCreated extends Mailable
{
    use Queueable, SerializesModels;

    public $childAccount;
    public $childActivationToken;
    public $parentAccount;
    public $parentActivationToken;

    public function __construct(User $childAccount, $childLogin, $childPassword, User $parentAccount = null, $parentLogin = null , $parentPassword = null)
    {
        $this->childAccount = $childAccount;
        $this->childLogin = $childLogin;
        $this->childPassword = $childPassword;
        $this->parentAccount = $parentAccount;
        $this->parentLogin = $parentLogin;
        $this->parentPassword = $parentPassword;
    }

    public function build()
    {
        return $this->view('emails.userCreated')
                    ->with([
                            'childLogin' => $this->childLogin,
                            'childPassword' => $this->childPassword,
                            'parentLogin' => $this->parentLogin,
                            'parentPassword' => $this->parentPassword
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
            view: 'emails.userCreated',
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
