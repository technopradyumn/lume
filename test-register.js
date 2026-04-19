import fs from 'fs';

async function test() {
  try {
    const boundary = "------WebKitFormBoundary" + Math.random().toString(36).substring(2);
    const body = `--${boundary}\r\nContent-Disposition: form-data; name="fullName"\r\n\r\ntest name\r\n` +
                 `--${boundary}\r\nContent-Disposition: form-data; name="email"\r\n\r\ntestemail123@gmail.com\r\n` +
                 `--${boundary}\r\nContent-Disposition: form-data; name="username"\r\n\r\ntestuser123\r\n` +
                 `--${boundary}\r\nContent-Disposition: form-data; name="password"\r\n\r\n123456\r\n` +
                 `--${boundary}--\r\n`;

    const response = await fetch('http://localhost:8000/api/v1/users/register', {
      method: 'POST',
      headers: {
        'Content-Type': `multipart/form-data; boundary=${boundary}`
      },
      body: body
    });

    const data = await response.text();
    console.log("SUCCESS:", response.status, data);
  } catch (error) {
    console.log("ERROR:", error);
  }
}

test();
