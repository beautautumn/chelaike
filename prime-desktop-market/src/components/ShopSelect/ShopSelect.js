import { fetch } from 'redux/modules/shops'
import createSelect from '../Select/createSelect'

export default createSelect('shops', { prompt: '选择车商', fetch })
