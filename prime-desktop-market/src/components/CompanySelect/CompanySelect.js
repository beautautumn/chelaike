import { fetch } from 'redux/modules/companies'
import createSelect from '../Select/createSelect'

export default createSelect('companies', { prompt: '选择市场', fetch })
