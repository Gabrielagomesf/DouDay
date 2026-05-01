import nodemailer from 'nodemailer';

interface EmailOptions {
  to: string;
  subject: string;
  template?: string;
  data?: any;
  html?: string;
  text?: string;
}

function escapeHtml(input: string) {
  return input
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

function renderTemplate(template: string, data: any) {
  const safeName = escapeHtml(String(data?.name ?? ''));
  if (template === 'password-reset') {
    const resetLink = String(data?.resetLink ?? '');
    const safeLink = escapeHtml(resetLink);
    return {
      subject: 'Redefinir senha - DuoDay',
      html: `
        <div style="font-family: Arial, sans-serif; line-height: 1.5; color: #111;">
          <h2 style="margin: 0 0 12px 0;">Olá${safeName ? `, ${safeName}` : ''}</h2>
          <p>Recebemos uma solicitação para redefinir sua senha no DuoDay.</p>
          <p>
            <a href="${safeLink}" style="display:inline-block; background:#7B61FF; color:#fff; padding:12px 16px; border-radius:10px; text-decoration:none;">
              Redefinir senha
            </a>
          </p>
          <p>Se você não solicitou isso, ignore este e-mail.</p>
          <p style="color:#666; font-size: 12px;">O link expira em 1 hora.</p>
        </div>
      `.trim(),
      text: `Olá${safeName ? `, ${safeName}` : ''}\n\nRedefina sua senha: ${resetLink}\n\nSe você não solicitou isso, ignore este e-mail. O link expira em 1 hora.`,
    };
  }

  if (template === 'password-reset-code') {
    const code = escapeHtml(String(data?.code ?? ''));
    return {
      subject: 'Código de verificação - DuoDay',
      html: `
        <div style="font-family: Arial, sans-serif; line-height: 1.5; color: #111;">
          <h2 style="margin: 0 0 12px 0;">Olá${safeName ? `, ${safeName}` : ''}</h2>
          <p>Seu código para redefinir a senha é:</p>
          <p style="font-size: 24px; letter-spacing: 4px; font-weight: 700; color: #7B61FF;">${code}</p>
          <p>Esse código expira em 10 minutos.</p>
          <p>Se você não solicitou isso, ignore este e-mail.</p>
        </div>
      `.trim(),
      text: `Olá${safeName ? `, ${safeName}` : ''}\n\nSeu código de verificação é: ${code}\nVálido por 10 minutos.`,
    };
  }

  return {
    subject: template,
    html: data?.html ? String(data.html) : '',
    text: data?.text ? String(data.text) : '',
  };
}

async function sendWithBrevo(options: EmailOptions) {
  const apiKey = process.env.BREVO_API_KEY;
  const senderEmail = process.env.BREVO_SENDER_EMAIL;
  const senderName = process.env.BREVO_SENDER_NAME || 'DuoDay';

  if (!apiKey || !senderEmail) {
    throw new Error('Brevo not configured: set BREVO_API_KEY and BREVO_SENDER_EMAIL');
  }

  let subject = options.subject;
  let htmlContent = options.html;
  let textContent = options.text;

  if ((!htmlContent && !textContent) && options.template) {
    const rendered = renderTemplate(options.template, options.data);
    subject = options.subject || rendered.subject;
    htmlContent = rendered.html;
    textContent = rendered.text;
  }

  const payload = {
    sender: { email: senderEmail, name: senderName },
    to: [{ email: options.to }],
    subject,
    htmlContent,
    textContent,
  };

  const resp = await fetch('https://api.brevo.com/v3/smtp/email', {
    method: 'POST',
    headers: {
      'accept': 'application/json',
      'content-type': 'application/json',
      'api-key': apiKey,
    },
    body: JSON.stringify(payload),
  });

  const bodyText = await resp.text();
  if (!resp.ok) {
    throw new Error(`Brevo send failed: ${resp.status} ${bodyText}`);
  }

  try {
    return JSON.parse(bodyText);
  } catch {
    return bodyText;
  }
}

export const sendEmail = async (options: EmailOptions) => {
  try {
    // Prefer Brevo API when configured
    if (process.env.BREVO_API_KEY) {
      return await sendWithBrevo(options);
    }

    // Fallback to SMTP (can also be Brevo SMTP)
    const transporter = nodemailer.createTransport({
      host: process.env.EMAIL_HOST,
      port: parseInt(process.env.EMAIL_PORT || '587'),
      secure: false,
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    let subject = options.subject;
    let html = options.html;
    let text = options.text;
    if ((!html && !text) && options.template) {
      const rendered = renderTemplate(options.template, options.data);
      subject = options.subject || rendered.subject;
      html = rendered.html;
      text = rendered.text;
    }

    const mailOptions = {
      from: process.env.EMAIL_FROM,
      to: options.to,
      subject,
      text,
      html,
    };

    const result = await transporter.sendMail(mailOptions);
    return result;
  } catch (error) {
    console.error('Email sending error:', error);
    throw error;
  }
};
