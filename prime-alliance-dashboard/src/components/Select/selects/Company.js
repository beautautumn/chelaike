import Company from 'models/company'
import createSelect from '../createSelect'

export default createSelect('company', { prompt: '选择车商', model: Company })
