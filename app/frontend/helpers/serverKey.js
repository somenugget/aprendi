const serverKey = () =>
  document.querySelector('body').dataset.vapidApplicationServerKey

const serverKeyWithoutPadding = () => {
  return serverKey()?.replace(/=/g, '')
}

// eslint-disable-next-line import/prefer-default-export
export { serverKeyWithoutPadding }
