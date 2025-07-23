let engineInitialized = false;
let appStarted = false;

document.addEventListener('DOMContentLoaded', function() {
  const startAppBtn = document.getElementById('start-app-btn');

  startAppBtn.addEventListener('click', function() {
    if (engineInitialized && !appStarted) {
      startApp();
    }
  });
});

function showStartButton() {
  const startAppBtn = document.getElementById('start-app-btn');
  startAppBtn.style.display = 'inline-block';
}

function hideLoadingIndicator() {
  const loader = document.querySelector('.loader');
  if (loader) {
    loader.style.display = 'none';
  }
}

function hideLandingPage() {
  const landingPage = document.getElementById('landing-page');
  landingPage.style.display = 'none';
}

window.addEventListener('flutter-initialized', function() {
  engineInitialized = true;
//   hideLoadingIndicator();
  showStartButton();
});

function startApp() {
  appStarted = true;
//   hideLandingPage();
  // Add any additional logic needed to start your Flutter app
}
