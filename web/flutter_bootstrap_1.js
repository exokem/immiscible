{{flutter_js}}
{{flutter_build_config}}

function getCanvasKitMaximumSurfaces() {
	const memory = navigator.deviceMemory || 4;
	const cpuCores = navigator.hardwareConcurrency || 2;

	if (memory <= 2 || cpuCores <= 2) {
		return 2; // Low-end device
	} else if (memory >= 8 && cpuCores >= 6) {
		return 8; // High-end device
	} else {
		return 4; // Medium-range device
	}
}

const userConfig = {
	renderer: '',
	canvasKitVariant: 'auto',
	canvasKitMaximumSurfaces: getCanvasKitMaximumSurfaces(),
};

// const loading = document.getElementById('loading-status')
// const loading = document.createElement('div');
// console.log(loading);
// document.body.appendChild(loading);

function updateLoadingStatus(status) {
	// console.log(status)
	// if (loading) {
	// 	loading.textContent = status
	// }
}

updateLoadingStatus("Starting...")

_flutter.loader.load({
	config: userConfig,
	onEntrypointLoaded: async function (engineInitializer) {
		console.log("Initialized Service Worker.");
		console.log("Ready for engine initialization.");

		updateLoadingStatus("Initializing engine...");
		const appRunner = await engineInitializer.initializeEngine();

		updateLoadingStatus("Finalizing...");
		await appRunner.runApp();
	},
});


// {{flutter_js}}
// {{flutter_build_config}}

// const loading = document.createElement('div');
// document.body.appendChild(loading);
// loading.textContent = "Loading Entrypoint...";
// _flutter.loader.load({
//   onEntrypointLoaded: async function(engineInitializer) {
//     loading.textContent = "Initializing engine...";
//     const appRunner = await engineInitializer.initializeEngine();

//     loading.textContent = "Running app...";
//     await appRunner.runApp();
//   }
// });