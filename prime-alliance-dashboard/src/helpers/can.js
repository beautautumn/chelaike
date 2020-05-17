/* eslint-disable */
export default function can(authority, targetUserId) {
  const { currentUser } = global.PrimeAllianceDashboard
  const isAllowed = currentUser.authorities.includes(authority)
  if (targetUserId) {
    const doesOwnByCurrentUser = currentUser.id === targetUserId
    return doesOwnByCurrentUser || isAllowed
  }
  return isAllowed
}

export function canEditAcquisitionTransfer(carId) {
  return true
  if (carId) {
    return can('牌证信息录入') && can('牌证信息查看')
  }
  return can('牌证信息录入')
}
/* eslint-enable */
