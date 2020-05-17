import { fetch } from 'redux/modules/insuranceCompanies'
import createSelect from '../Select/createSelect'

export default createSelect('insuranceCompanies', { prompt: '选择保险公司', fetch })
