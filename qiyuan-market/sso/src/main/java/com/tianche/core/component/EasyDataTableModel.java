package com.tianche.core.component;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

public abstract class EasyDataTableModel<T> {
	private long total;

    private List<T> rows;

    private HttpServletRequest req;

    protected EasyDataTableModel() {
    }

    protected EasyDataTableModel(HttpServletRequest req) {
        this.req = req;
    }

    /**
     * 分页加字段排序
     *
     * @param page
     * @param size
     * @param sort
     * @param order
     * @return
     */
    public List<T> fechData(int page, int size, String sort, String order) throws Exception {
        return fechData(page, size);
    }

    /**
     * 普通分页方法
     *
     * @param page
     * @param size
     * @return
     */
    public List<T> fechData(int page, int size) throws Exception {
        return fechData();
    }

    /**
     * 不分页方法
     *
     * @return
     */
    public List<T> fechData() throws Exception {
        return null;
    }

    private void buildData() {
        try {
            if (req == null) {
                rows = fechData();
            } else {
                String page = req.getParameter("page");
                String size = req.getParameter("rows");
                String sort = req.getParameter("sort");
                String order = req.getParameter("order");
                if (page != null && size != null) {
                    rows = fechData(Integer.valueOf(page), Integer.valueOf(size), sort, order);
                }
            }

            if(rows == null){
                rows = new ArrayList<T>();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public long getTotal() {
        if (total == 0) {
            buildData();
        }
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    public List<T> getRows() {
        if (rows == null) {
            buildData();
        }
        return rows;
    }

    public void setRows(List<T> rows) {
        this.rows = rows;
    }
}
