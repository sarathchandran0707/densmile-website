document.getElementById('apptForm').addEventListener('submit', function(e){
  e.preventDefault();
  const name = document.getElementById('fName').value;
  const service = document.getElementById('fService').value;
  const date = document.getElementById('fDate').value;
  const time = document.getElementById('fTime').value;
  document.getElementById('confirmDetail').textContent =
    `Thanks, ${name}! We've noted your request for ${service} on ${date || 'your preferred date'} (${time}). Our front desk will call to confirm.`;
  this.style.display = 'none';
  document.getElementById('apptConfirm').classList.add('show');
});
document.getElementById('apptAnother').addEventListener('click', function(){
  document.getElementById('apptForm').reset();
  document.getElementById('apptForm').style.display = 'grid';
  document.getElementById('apptConfirm').classList.remove('show');
});
