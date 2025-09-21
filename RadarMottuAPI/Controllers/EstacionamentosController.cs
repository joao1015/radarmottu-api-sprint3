using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RadarMottuAPI.Data;
using RadarMottuAPI.Models;

namespace RadarMottuAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EstacionamentosController : ControllerBase
    {
        private readonly AppDbContext _context;

        public EstacionamentosController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Estacionamento>>> GetAll()
        {
            return await _context.Estacionamentos.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Estacionamento>> GetById(int id)
        {
            var estacionamento = await _context.Estacionamentos.FindAsync(id);
            return estacionamento == null ? NotFound() : Ok(estacionamento);
        }

        [HttpPost]
        public async Task<ActionResult<Estacionamento>> Create(Estacionamento est)
        {
            _context.Estacionamentos.Add(est);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetById), new { id = est.Id }, est);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Estacionamento est)
        {
            if (id != est.Id) return BadRequest();

            _context.Entry(est).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var est = await _context.Estacionamentos.FindAsync(id);
            if (est == null) return NotFound();

            _context.Estacionamentos.Remove(est);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
