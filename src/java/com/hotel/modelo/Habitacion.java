package com.hotel.modelo;

public class Habitacion {
    private int id;
    private String idHabitacion;
    private String estado;
    private Integer idCliente;
    private String tipoHabitacion;
    private double precioNoche;
    private int capacidad;

    public Habitacion() {
    }

    public Habitacion(int id, String idHabitacion, String estado, Integer idCliente, String tipoHabitacion, double precioNoche, int capacidad) {
        this.id = id;
        this.idHabitacion = idHabitacion;
        this.estado = estado;
        this.idCliente = idCliente;
        this.tipoHabitacion = tipoHabitacion;
        this.precioNoche = precioNoche;
        this.capacidad = capacidad;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getIdHabitacion() {
        return idHabitacion;
    }

    public void setIdHabitacion(String idHabitacion) {
        this.idHabitacion = idHabitacion;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Integer getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Integer idCliente) {
        this.idCliente = idCliente;
    }

    public String getTipoHabitacion() {
        return tipoHabitacion;
    }

    public void setTipoHabitacion(String tipoHabitacion) {
        this.tipoHabitacion = tipoHabitacion;
    }

    public double getPrecioNoche() {
        return precioNoche;
    }

    public void setPrecioNoche(double precioNoche) {
        this.precioNoche = precioNoche;
    }

    public int getCapacidad() {
        return capacidad;
    }

    public void setCapacidad(int capacidad) {
        this.capacidad = capacidad;
    }
}

