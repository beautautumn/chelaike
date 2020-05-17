import { all, fork } from 'redux-saga/effects';
import error from './error';
import auth from './auth';
import profile from './profile';
import loan from './loan';
import transfer from './transfer';
import repayment from './repayment';
import stores from './stores';
import company from './company';
import series from './series';
import user from './user';
import role from './role';
import inventory from './inventory';
import founderInventory from './founderInventory';
import inventoryDetail from './inventoryDetail';
import founderInventoryDetail from './founderInventoryDetail';

export default function* root() {
  yield all([
    fork(error),
    fork(auth),
    fork(profile),
    fork(loan),
    fork(transfer),
    fork(stores),
    fork(inventory),
    fork(inventoryDetail),
    fork(repayment),
    fork(company),
    fork(user),
    fork(role),
    fork(series),
    fork(founderInventory),
    fork(founderInventoryDetail)
  ]);
}
