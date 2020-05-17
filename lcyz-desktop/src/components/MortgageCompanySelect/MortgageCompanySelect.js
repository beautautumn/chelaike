import { fetch } from 'redux/modules/mortgageCompanies'
import createSelect from '../Select/createSelect'

export default createSelect('mortgageCompanies', { prompt: '选择按揭公司', fetch })
