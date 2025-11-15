package com.hotel.modelo;

public class ProductoVendido {
    private long id;
    private long idProducto;
    private long cantidad;
    private long idVenta;
    private double precioUnitario;

    public ProductoVendido() {
    }

    public ProductoVendido(long id, long idProducto, long cantidad, long idVenta, double precioUnitario) {
        this.id = id;
        this.idProducto = idProducto;
        this.cantidad = cantidad;
        this.idVenta = idVenta;
        this.precioUnitario = precioUnitario;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(long idProducto) {
        this.idProducto = idProducto;
    }

    public long getCantidad() {
        return cantidad;
    }

    public void setCantidad(long cantidad) {
        this.cantidad = cantidad;
    }

    public long getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(long idVenta) {
        this.idVenta = idVenta;
    }

    public double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }
}

