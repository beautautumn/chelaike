import { fetch } from 'redux/modules/channels'
import createSelect from '../Select/createSelect'

export default createSelect('channels', { prompt: '选择渠道', fetch })
