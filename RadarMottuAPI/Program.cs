using Microsoft.EntityFrameworkCore;
using RadarMottuAPI.Data;

var builder = WebApplication.CreateBuilder(args);

// Add controllers and Swagger
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Busca a connection string de forma segura
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection")
                       ?? Environment.GetEnvironmentVariable("ConnectionStrings__DefaultConnection");

// Usa Azure SQL (SqlServer)
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

var app = builder.Build();

// Ativa Swagger SEMPRE (produção e desenvolvimento)
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "RadarMottuAPI v1");
    c.RoutePrefix = string.Empty; // Mostra Swagger direto na raiz (ex: site.com/)
});

app.UseAuthorization();

app.MapControllers();

app.Run();
