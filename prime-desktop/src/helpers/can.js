export function canCrossShop(shopId) {
  const currentUser = global.PrimeDesktop.currentUser
  const { company } = currentUser
  if (!shopId ||
      !currentUser.shopId ||
      currentUser.shopId === shopId ||
      company.settings.unifiedManagement) {
    return true
  }
  return currentUser.settings.crossShopEdit
}

export default function can(authority, targetUserId, shopId) {
  const currentUser = global.PrimeDesktop.currentUser
  // 有提供权限就判断权限和跨店权限，不然就只判断跨店权限
  if (authority) {
    const isAllowed = currentUser.authorities.includes(authority)
    if (targetUserId) {
      const doesOwnByCurrentUser = currentUser.id === targetUserId
      return doesOwnByCurrentUser || isAllowed
    }
    return isAllowed && canCrossShop(shopId)
  }
  return canCrossShop(shopId)
}


export function canEditAcquisitionTransfer(carId) {
  if (carId) {
    return can('牌证信息录入') && can('牌证信息查看')
  }
  return can('牌证信息录入')
}
