package com.hotel.modelo;
import java.sql.Timestamp;
import java.util.List;

public class Venta {
    private long id;
    private Timestamp fecha;
    private double total;
    private double iva5;
    private double iva19;
    private double exento;
    private String tipoPago;
    private Integer idCliente;
    private Integer idHabitacion;
    private String tipoVenta;
    private List<ProductoVendido> productos;

    public Venta() {
    }

    public Venta(long id, Timestamp fecha, double total, double iva5, double iva19, double exento, 
                 String tipoPago, Integer idCliente, Integer idHabitacion, String tipoVenta) {
        this.id = id;
        this.fecha = fecha;
        this.total = total;
        this.iva5 = iva5;
        this.iva19 = iva19;
        this.exento = exento;
        this.tipoPago = tipoPago;
        this.idCliente = idCliente;
        this.idHabitacion = idHabitacion;
        this.tipoVenta = tipoVenta;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Timestamp getFecha() {
        return fecha;
    }

    public void setFecha(Timestamp fecha) {
        this.fecha = fecha;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public double getIva5() {
        return iva5;
    }

    public void setIva5(double iva5) {
        this.iva5 = iva5;
    }

    public double getIva19() {
        return iva19;
    }

    public void setIva19(double iva19) {
        this.iva19 = iva19;
    }

    public double getExento() {
        return exento;
    }

    public void setExento(double exento) {
        this.exento = exento;
    }

    public String getTipoPago() {
        return tipoPago;
    }

    public void setTipoPago(String tipoPago) {
        this.tipoPago = tipoPago;
    }

    public Integer getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Integer idCliente) {
        this.idCliente = idCliente;
    }

    public Integer getIdHabitacion() {
        return idHabitacion;
    }

    public void setIdHabitacion(Integer idHabitacion) {
        this.idHabitacion = idHabitacion;
    }

    public String getTipoVenta() {
        return tipoVenta;
    }

    public void setTipoVenta(String tipoVenta) {
        this.tipoVenta = tipoVenta;
    }

    public List<ProductoVendido> getProductos() {
        return productos;
    }

    public void setProductos(List<ProductoVendido> productos) {
        this.productos = productos;
    }
}

