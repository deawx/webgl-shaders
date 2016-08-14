import parseLocationHash from 'javascript/utility/parseLocationHash'
import setLocationHash from 'javascript/utility/setLocationHash'

import assign from 'lodash/assign'

const DEFAULT_CONFIG = {
  x_min: -100.0,
  x_max:  100.0,
  y_min: -100,
  y_max:  100,

  angle1: Math.PI / 2,
  angle2: Math.PI / 2,

  brightness: 400.0,
  colorset: 0,
  fractal: 0,
  exponent: 2,
  speed: 16,
  supersamples: 1
}

const Config = {
  getConfig(locationHash = parseLocationHash()) {
    return assign({}, DEFAULT_CONFIG, locationHash)
  },
  setConfig(configChanges) {
    const newConfig = assign({}, Config.getConfig(), configChanges)

    setLocationHash(newConfig)
  },
  defaults: DEFAULT_CONFIG
}

export default Config
