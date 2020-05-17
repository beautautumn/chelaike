import { fetch } from 'redux/modules/roles'
import createSelect from '../Select/createSelect'

export default createSelect('roles', { prompt: '选择角色', fetch })
