import IntentionLevel from 'models/intention/level'
import createSelect from '../createSelect'

export default createSelect('intentionLevel', { prompt: '选择用户等级', model: IntentionLevel })
