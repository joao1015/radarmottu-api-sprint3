using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using RadarMottuAPI.Models;

namespace RadarMottuAPI.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Estacionamento> Estacionamentos => Set<Estacionamento>();
        public DbSet<Moto> Motos => Set<Moto>();
        public DbSet<Posicionamento> Posicionamentos => Set<Posicionamento>();
    }
}
