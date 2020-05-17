package com.ct.erp.list.model;

import java.util.Comparator;

public class ComparatorElement implements Comparator {

	@Override
	public int compare(Object o1, Object o2) {
		// TODO Auto-generated method stub
		AbsElement element1 = (AbsElement) o1;
		AbsElement element2 = (AbsElement) o2;
		if(element1.getShowOrder()!=null&&element2.getShowOrder()!=null){
			return element1.getShowOrder().compareTo(element2.getShowOrder());
		}else{
			return 0;
		}
		
	}

}
