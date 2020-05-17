import Channel from 'models/channel'
import createSelect from '../createSelect'

export default createSelect('channel', { prompt: '选择渠道', model: Channel })
