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
      // eslint-disable-next-line no-console
      console.log('Service worker installing')
    } else if (registration.waiting) {
      // eslint-disable-next-line no-console
      console.log('Service worker installed')
    } else if (registration.active) {
      // eslint-disable-next-line no-console
      console.log('Service worker active')

      if (onActive) {
        onActive(registration)
      }
    }
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error(`Registration failed with ${error}`)
  }
}

registerServiceWorker()
