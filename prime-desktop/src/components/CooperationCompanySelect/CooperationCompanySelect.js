import { fetch } from 'redux/modules/cooperationCompanies'
import createSelect from '../Select/createSelect'

export default createSelect('cooperationCompanies', { prompt: '选择合作商家', fetch })
