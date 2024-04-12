// Call this function to reveal the email address
function revealEmail() {
  const emailElement = document.getElementById("emailLink");
  const encodedEmail = "ZGF2aWQudC5vY29ubm9yQG91dGxvb2suaWU="; // Base64-encoded email address
  const decodedEmail = atob(encodedEmail);
  emailElement.href = "mailto:" + decodedEmail;
  emailElement.textContent = decodedEmail;
}

// Call the revealEmail function when the page is loaded
window.onload = revealEmail;