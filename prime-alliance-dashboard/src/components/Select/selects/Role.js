import Role from 'models/role'
import createSelect from '../createSelect'

export default createSelect('role', { prompt: '选择角色', model: Role })
