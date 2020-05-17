import { fetch } from 'redux/modules/intentionLevels'
import createSelect from '../Select/createSelect'

export default createSelect('intentionLevels', { prompt: '选择等级', fetch })
