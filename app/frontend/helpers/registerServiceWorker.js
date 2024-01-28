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
      onActive(registration)
    }
  } catch (error) {
    console.error(`Registration failed with ${error}`)
  }
}

registerServiceWorker(async (registration) => {
  if (window.Notification.permission === 'granted') {
    setTimeout(() => {
      console.log('push')
      console.log(registration.showNotification)
      registration.showNotification('Notification with ServiceWorker', {
        body: 'Notification with ServiceWorker',
        vibrate: [200, 100, 200, 100, 200, 100, 200],
        tag: 'vibration-sample',
      })
    }, 2000)
  } else {
    document.querySelector('body').addEventListener('click', async () => {
      const permission = await window.Notification.requestPermission()
      if (permission === 'granted') {
        alert('granted')
      }
    })
  }
})
