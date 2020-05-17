import { fetch } from 'redux/modules/defeatReasons'
import createSelect from '../Select/createSelect'

export default createSelect('defeatReasons', { prompt: '选择战败原因', fetch })
