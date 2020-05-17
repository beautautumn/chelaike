package com.ct.erp.lib;

import org.hibernate.cfg.reveng.DelegatingReverseEngineeringStrategy;
import org.hibernate.cfg.reveng.ReverseEngineeringStrategy;
import org.hibernate.cfg.reveng.TableIdentifier;
import org.hibernate.mapping.ForeignKey;
import org.hibernate.mapping.Table;

import java.util.List;

public class CloudtrendReverseStrategy extends
        DelegatingReverseEngineeringStrategy {
	@Override
	public boolean isManyToManyTable(Table table) {
		/*
		Iterator itpc = table.getPrimaryKey().getColumnIterator();
		boolean isManyToMany = true;
		for (Iterator itk = table.getForeignKeyIterator();itk.hasNext();)
		{
			ForeignKey fk = (ForeignKey)itk.next();
			boolean allFinded = true;
			for (Iterator itfc = fk.getColumnIterator(); itfc.hasNext();)
			{
				if (!table.getPrimaryKey().containsColumn((Column)itfc.next()))
				{
					allFinded = false;
					break;
				}
			}
			 
			if (!allFinded){
				isManyToMany = false;
				break;
			}
		}
		
		return isManyToMany;
		*/
		return super.isManyToManyTable(table);
	}

	@Override
	public String foreignKeyToCollectionName(String keyname,
                                             TableIdentifier fromTable, List fromColumns,
                                             TableIdentifier referencedTable, List referencedColumns,
                                             boolean uniqueReference) {
		String fromName = fromTable.getName();
		String refName = referencedTable.getName();
		if (fromName.equals(refName))
		{
			String result = "sub" + Character.toUpperCase(fromName.charAt(5)) + fromName.substring(6) +"s";
			return result;
		} 
		else
		{
			String result = super.foreignKeyToCollectionName(keyname, fromTable, fromColumns,
					referencedTable, referencedColumns, uniqueReference);
			return Character.toLowerCase(result.charAt(3))+result.substring(4);
		}
	}

	@Override
	public String foreignKeyToManyToManyName(ForeignKey fromKey,
                                             TableIdentifier middleTable, ForeignKey toKey,
                                             boolean uniqueReference) {
		String result = super.foreignKeyToManyToManyName(fromKey, middleTable, 
				toKey, uniqueReference);
		return Character.toLowerCase(result.charAt(3))+result.substring(4);
	}

	public CloudtrendReverseStrategy(ReverseEngineeringStrategy delegate) {
		super(delegate);
	}

	@Override
	public String foreignKeyToEntityName(String keyname,
                                         TableIdentifier fromTable, List fromColumnNames,
                                         TableIdentifier referencedTable, List referencedColumnNames,
                                         boolean uniqueReference) {
		String fromName = fromTable.getName();
		String refName = referencedTable.getName();
		if (fromName.equals(refName))
		{
			String result = "parent" + Character.toUpperCase(fromName.charAt(5)) + fromName.substring(6) ;
			return result;

		}
		else 
		{
			String result = super.foreignKeyToEntityName(keyname, fromTable, 
					fromColumnNames, referencedTable, referencedColumnNames, uniqueReference);
			return Character.toLowerCase(result.charAt(3))+result.substring(4);
		}
	}

	@Override
	public String tableToClassName(TableIdentifier tableIdentifier) {
		String temp = super.tableToClassName(tableIdentifier);
		int dotIndex = temp.lastIndexOf('.');
		String result = temp.substring(0,dotIndex)+"."+temp.substring(dotIndex+1).substring(3);
		return result;
	}

}
