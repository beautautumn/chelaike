import Warranty from 'models/warranty'
import createSelect from '../createSelect'

export default createSelect('warranty', { prompt: '选择等级', model: Warranty })
