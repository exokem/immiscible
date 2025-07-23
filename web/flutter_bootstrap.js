{{flutter_js}}
{{flutter_build_config}}

let isReady = false;

const loadingScreen = document.getElementById('loading-screen');

loadingScreen.onclick = async () => {
	if (isReady) {
		loadingScreen.style.transition = 'transform 400ms ease-in-out';
		loadingScreen.style.transform = 'translateY(-100vh)';
		await new Promise(resolve => setTimeout(resolve, 400));
		if (document.documentElement.requestFullscreen) {
			document.documentElement.requestFullscreen();
		}
		loadingScreen.remove();
	}
}

const loading = document.getElementById('loading-status');
loading.textContent = "Starting...";

const spinner = document.getElementById('spinner');

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    loading.textContent = "Initializing engine...";
    const appRunner = await engineInitializer.initializeEngine();

    loading.textContent = "Finalizing...";
    await appRunner.runApp();

	spinner.remove();
	loading.textContent = "Tap to start";
	isReady = true;
  }
});