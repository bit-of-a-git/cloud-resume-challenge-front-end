// Call this function to reveal the email address
function revealEmail() {
  var emailElement = document.getElementById("emailLink");
  var encodedEmail = "ZGF2aWQudC5vY29ubm9yQG91dGxvb2suaWU="; // Base64-encoded email address
  var decodedEmail = atob(encodedEmail);
  emailElement.href = "mailto:" + decodedEmail;
  emailElement.textContent = decodedEmail;
}

// Call the revealEmail function when the page is loaded
window.onload = revealEmail;