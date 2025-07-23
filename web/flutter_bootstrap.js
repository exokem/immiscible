{{flutter_js}}
{{flutter_build_config}}

let isReady = false;

const loadingScreen = document.getElementById('loading-screen');
const loading = document.getElementById('loading-status');
const percent = document.getElementById('loading-percent');
const barContainer = document.getElementById('bar-container');
const percentOverlay = document.getElementById('loading-percent-overlay');
const spinner = document.getElementById('spinner');
const progressBar = document.getElementById('progress-bar');

const hideLoadingScreen = async () => {
	if (document.documentElement.requestFullscreen) {
		document.documentElement.requestFullscreen();
	}
	await new Promise(resolve => setTimeout(resolve, 200));
	loadingScreen.style.transition = 'transform 800ms ease-in-out';
	loadingScreen.style.transform = 'translateY(-100vh)';
	await new Promise(resolve => setTimeout(resolve, 800));
	loadingScreen.remove();
}

loadingScreen.onclick = hideLoadingScreen;

let progress = 0;
let currentPhase = '';


const setProgress = (value) => {
	progress = Math.min(100, value);
	percent.textContent = `${progress}%`;
	percentOverlay.textContent = percent.textContent;
	percentOverlay.style.clipPath = `rect(${100 - progress}% 100% 100% 0%)`;
	// progressBar.style.height = `${progress}%`;
}

const startPhase = async (phase, endPercent, minTick, maxTick) => {
	currentPhase = phase;
	loading.textContent = phase;

	while (currentPhase === phase && progress < endPercent) {
		let tick = Math.floor(Math.random() * (minTick - maxTick + 1)) + maxTick;
		await new Promise(resolve => setTimeout(resolve, tick));
		setProgress(progress + 1);
	}

	if (progress < endPercent)
		setProgress(endPercent);
}

startPhase('Starting...', 67, 50, 100);

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
	startPhase('Initializing engine...', 98, 5, 10);

    const appRunner = await engineInitializer.initializeEngine();

	startPhase('Finalizing', 100, 5, 10);
    await appRunner.runApp();

	setProgress(100);
	// spinner.remove();
	loading.textContent = "> Tap to start <";
	isReady = true;
  }
});