import { fetch } from 'redux/modules/warranties'
import createSelect from '../Select/createSelect'

export default createSelect('warranties', { prompt: '选择等级', fetch })
