import { schema } from 'normalizr';

export const roleSchema = new schema.Entity('roles');
export const roleArraySchema = new schema.Array(roleSchema);
export const userSchema = new schema.Entity('users', {
  authorityRole: roleSchema
});
export const userArraySchema = new schema.Array(userSchema);
export const loanSchema = new schema.Entity('loans');
export const loanArraySchema = new schema.Array(loanSchema);
export const transferSchema = new schema.Entity('transfers');
export const transferArraySchema = new schema.Array(transferSchema);
export const storesSchema = new schema.Entity('stores');
export const storesArraySchema = new schema.Array(storesSchema);
export const repaymentSchema = new schema.Entity('repayments');
export const repaymentArraySchema = new schema.Array(repaymentSchema);
export const companySchema = new schema.Entity('companies');
export const companyArraySchema = new schema.Array(companySchema);
export const inventorySchema = new schema.Entity('inventories');
export const inventoryArraySchema = new schema.Array(inventorySchema);
export const inventoryDetailSchema = new schema.Entity('inventoryDetails');
export const founderInventorySchema = new schema.Entity('founderInventories');
export const founderInventoryArraySchema = new schema.Array(
  founderInventorySchema
);
export const founderInventoryDetailSchema = new schema.Entity(
  'founderInventoryDetails'
);
/*export const inventoryDetailObjectSchema = new schema.Object(
  inventoryDetailSchema
);*/
