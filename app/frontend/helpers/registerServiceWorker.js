const registerServiceWorker = async (onActive) => {
  if (!('serviceWorker' in navigator)) {
    return
  }

  try {
    const registration = await navigator.serviceWorker.register(
      '/service-worker.js',
      {
        scope: '/',
      },
    )
    if (registration.installing) {
      console.log('Service worker installing')
    } else if (registration.waiting) {
      console.log('Service worker installed')
    } else if (registration.active) {
      console.log('Service worker active')

      if (onActive) {
        onActive(registration)
      }
    }
  } catch (error) {
    console.error(`Registration failed with ${error}`)
  }
}

registerServiceWorker()
